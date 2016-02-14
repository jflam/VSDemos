
# Working with Pandas dataframes
# Send to Python Interactive Window with CTRL+E, CTRL+E

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Read a Pandas data frame in and dump its structure

column_names = ["ID", "name", "city", "country", "IATA_FAA", "ICAO", "lat", "lon", "altitude", "timezone", "DST", "Region"]
airports = pd.read_csv("../RTVSDemos/airports.dat", names = column_names)
airports.head() # default is 5
airports.head(20)

# Get all airports in the United States

# Construct a Boolean Pandas data series for country matches

usa = airports["country"] == "United States"
type(usa)

# Use that boolean data series to select the rows and return a new dataframe

usa_airports = airports[usa]
type(usa_airports)

# Can do above in a single expression

usa_airports2 = airports[airports["country"] == "United States"]

# Assert equality of the data frames

from pandas.util.testing import assert_frame_equal
assert_frame_equal(usa_airports, usa_airports2)

# Get a list of unique countries with airports

airports["country"].unique()
len(airports["country"].unique())

# Now switch to IPython mode in the Interactive Window - make sure to reset the Interactive Window
# https://github.com/Microsoft/PTVS/wiki/Using-IPython-with-PTVS

# Experiment with things

from IPython.display import display, HTML
display(airports)
HTML(airports.to_html())
