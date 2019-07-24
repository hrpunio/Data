#!/bin/bash

## 13-04--11.07 (3 miesiace)
perl mevo_dist_log_agg.pl \
  ./201904/MEVO_MONTHLY_LOG.log \
  ./201905/MEVO_MONTHLY_LOG.log \
  ./201906/MEVO_MONTHLY_LOG.log \
  ./201907/MEVO_MONTHLY_LOG.log > mevo_dist_log_agg.csv
