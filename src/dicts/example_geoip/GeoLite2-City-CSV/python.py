#!/usr/bin/env python3

import csv
with open('GeoLite2-City-Locations-en.csv', 'rb') as csvfilein:
    with open('GeoLite2-City-Locations-en-quoted.csv', 'w') as csvfileout:
        csvreader = csv.DictReader(csvfilein, delimiter=',')
        writer = csv.DictWriter(csvfileout, fieldnames=csvreader.fieldnames, quoting=csv.QUOTE_ALL)
        writer.writeheader()
        for row in csvreader:
            writer.writerow(row)
