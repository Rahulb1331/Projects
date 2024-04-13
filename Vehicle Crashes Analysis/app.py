import streamlit as st
import pandas as pd
import numpy as np
import pydeck as pdk
import plotly.express as px

DATA_URL = (
"Motor_Vehicle_Collisions_-_Crashes.csv"
)

st.title("Motor Vehicle Collisions in New York City")
st.markdown("This application is a streamlit dashboard that can be used "
"to analyze motor vehicle collisions in NYC")

# decorator added to the load_data function to avoid reloading of the large dataset whenever changes done dynamically on the webapp.
@st.cache(persist=True)
def load_data(nrows):
    data = pd.read_csv(DATA_URL, nrows = nrows, parse_dates=[['CRASH_DATE','CRASH_TIME']])
    data.dropna(subset=['LATITUDE','LONGITUDE'], inplace = True)
    lowercase = lambda x: str(x).lower()
    data.rename(lowercase, axis='columns', inplace = True)
    data.rename(columns={'crash_date_crash_time': 'date/time'}, inplace= True)
    return data

#Loading 100000 rows from the 1.67 million rows, so as to reduce the computational load and analyze efficiently. 
data = load_data(100000)
original_data = data


st.header("Where are the most people injured in NYC?")
injured_people = st.slider("Number of injured persons in vehicle collision", 0, 19)
st.map(data.query("injured_persons >= @injured_people")[["latitude","longitude"]].dropna(how = 'any'))


st.header("How many collisions occur during a given time of day?")
hour = st.slider("Hour to look at", 0, 23)
data = data[data['date/time'].dt.hour== hour]

# An interactive 3D geographical map to display the vehicle collisions in a particular hour frame within the New York City.
st.markdown("Vehicle collisions between hour %i:00 and %i:00" %(hour, (hour + 1) % 24))
midpoint = (np.average(data['latitude']),np.average(data['longitude']))

st.write(pdk.Deck(
    map_style="mapbox://styles/mapbox/light-v9",
    initial_view_state={
    "latitude" : midpoint[0],
    "longitude" : midpoint[1],
    "zoom": 11,
    "pitch":50
    },
    layers = [
        pdk.Layer(
        "HeaxgonLayer",
        data = data[['date/time','latitude','longitude']],
        get_position = ['longitude','latitude'],
        radius = 100,
        extruded = True,
        pickable = True,
        elevation_scale = 4,
        elevation_range = [0,1000],
        ),
    ],
))


#Bar chart to give a breakdown on the number of crashes by minutes within a particular hour.
st.subheader("Breakdown by minute between %i:00 and %i:00"%(hour,(hour+1)%24))
filtered = data[
    (data['date/time'].dt.hour >= hour) & (data['date/time'].dt.hour <(hour + 1))
]

hist = np.histogram(filtered['date/time'].dt.minute, bins = 60, range = (0,60))[0]
chart_data = pd.DataFrame({'minute': range(60), 'crashes':hist})
fig = px.bar(chart_data,x = 'minute', y='crashes', hover_data=['minute', 'crashes'], height = 400)
st.write(fig)

# Displays the top 5 most dangerous streets for the following set of people, Pedestrians, Cyclists and Motorists.
st.header("Top 5 dangerous streets by affected group")
select= st.selectbox('Affected type of people', ['Pedestrians', 'Cyclists', 'Motorists'])

if select == 'Pedestrians':
    st.write(original_data.query("injured_pedestrians >= 1")[["on_street_name", "injured_pedestrians"]].sort_values(by =['injured_pedestrians'], ascending  = False).dropna(how='any')[:5])

elif select == "Cyclists":
    st.write(original_data.query("injured_cyclists >= 1")[["on_street_name", "injured_cyclists"]].sort_values(by =['injured_cyclists'], ascending  = False).dropna(how='any')[:5])

else:
    st.write(original_data.query("injured_motorists >= 1")[["on_street_name", "injured_motorists"]].sort_values(by =['injured_motorists'], ascending  = False).dropna(how='any')[:5])

if st.checkbox("Show Raw Data", False):
    st.subheader('Raw Data')
    st.write(data)
