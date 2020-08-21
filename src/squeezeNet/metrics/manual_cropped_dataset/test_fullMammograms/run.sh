set -x

python ../join_dataset_results.py   cropped_test_list.csv   probabilities.csv   -o test_fullMammograms_squeezenet.csv

time \
python ../metrics.py  	-i test_fullMammograms_squeezenet.csv  \
			-o test_metrics.txt \
			-r test_roc_curve.txt  \
			-p test_pr_curve.txt \
			-tr ../val_roc_curve.txt \
		        -tp ../val_pr_curve.txt  \
			> test_log.txt

cat test_log.txt

gnuplot <<< " \
	set terminal png size 800,600; \
	set output 'test_best_roc_curve.png'; \
	set xlabel '1 - Specificity'; \
	set ylabel 'Sensitivity'; \
	plot [0:1][0:1] 'test_roc_curve.txt'         using 3:4 with lines; \
	set output 'test_best_precision_recall.png'; \
	set xlabel 'Recall'; \
	set ylabel 'Precision'; \
	plot [0:1][0:1] 'test_pr_curve.txt'          using 3:4 with lines; \
"

eog test_best_roc_curve.png &
eog test_best_precision_recall.png &

set +x