# Valid project
mkdir -p proj_ok/rtl proj_ok/reports
echo "module alu; endmodule" > proj_ok/rtl/alu.v
echo "module ctrl; endmodule" > proj_ok/rtl/ctrl.sv
echo "slack (MET) 0.35" > proj_ok/reports/timing.txt

./script.sh proj_ok;  echo "exit=$?"     # expect exit=0
cat proj_ok/results/run_summary.txt
cat proj_ok/results/source_files.txt

# Missing timing report
mkdir -p proj_bad/rtl
./script.sh proj_bad; echo "exit=$?"      # expect error + exit=3

# Nonexistent directory
./script.sh nothere;  echo "exit=$?"      # expect error + exit=2

# Empty rtl folder
mkdir -p proj_empty/rtl proj_empty/reports
touch proj_empty/reports/timing.txt
./script.sh proj_empty; echo "exit=$?"    # expect FAILED + exit=6
