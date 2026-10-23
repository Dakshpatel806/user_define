#!/usr/bin/env python3
import csv

file = open("design_metrics.csv", "r")
reader = csv.reader(file)

next(reader)  # Skip header

setup = 0
count = 0
max_area = 0
total_power = 0

for row in reader:
    setup += float(row[1])
    count += 1

    if float(row[3]) > max_area:
        max_area = float(row[3])
        module = row[0]

    total_power += float(row[4])

print("Average setup time:", setup / count, "ns")
print("Largest area module:", module)
print("Total dynamic power:", total_power, "mW")

file.close()

