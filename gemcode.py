import datetime, calendar, requests

API_KEY = "AIzaSyCNd3OWwHFDxhTzbeYonZMd4nCC2yPGxMI" # Replace with your API key

def fetch_travel_time(origin, destination, departure_time):
  url = f"https://maps.googleapis.com/maps/api/directions/json?origin={origin}&destination={destination}&alternatives=true&key={API_KEY}&departure_time={calendar.timegm(departure_time.utctimetuple())}&traffic_model=best_guess"
  response = requests.get(url)
  data = response.json()

  if data['status'] == 'OK':
    return [[leg['duration_in_traffic']['value'] / 60 for leg in route['legs']] for route in data['routes']]
  else:
    print(f"Error fetching travel time: {data['status']}")
    return None

def analyze_traffic(travel_times, baseline_time):
  results = []
  for route_times in travel_times:
    route_results = []
    for time in route_times:
      total_extra_time = time - baseline_time
      congestion_threshold = baseline_time * 0.20

      time_in_congestion = max(0, total_extra_time - congestion_threshold)
      time_in_slow_move = max(0, total_extra_time) - time_in_congestion

      traffic_category = "No congestion"
      if time_in_congestion > 0:
        if time_in_congestion >= 5:
          traffic_category = f"{time_in_congestion:.2f} min heavy congestion"
        elif time_in_congestion >= 2:
          traffic_category = f"{time_in_congestion:.2f} min medium traffic"
        else:
          traffic_category = f"{time_in_congestion:.2f} min light congestion"

      route_results.append({
        "time": time,
        "extra_time": total_extra_time,
        "congestion": time_in_congestion,
        "slow_move": time_in_slow_move,
        "category": traffic_category
      })
    results.append(route_results)
  return results

def main():
  origin = "24.85085,67.01778"
  destination = "24.8657238,67.0142184"
  baseline_time = datetime.datetime(2024, 12, 14, 3, 0)

  baseline_travel_times = fetch_travel_time(origin, destination, baseline_time)
  if baseline_travel_times:
    baseline_travel_time = baseline_travel_times[0][0] #Use the first route's baseline time
    initial_time = datetime.datetime.utcnow()
    times = [initial_time + datetime.timedelta(minutes=i * 10) for i in range(6)]

    travel_times = [fetch_travel_time(origin, destination, t) for t in times]
    if all(travel_times):
      traffic_analysis = analyze_traffic(travel_times, baseline_travel_time)

      for route_index, route_data in enumerate(traffic_analysis):
        print(f"\nRoute {route_index + 1}:")
        for i, analysis in enumerate(route_data):
          print(f"  Time: {times[i].strftime('%H:%M')}, Travel Time: {analysis['time']:.2f} min, Extra Time: {analysis['extra_time']:.2f} min, Congestion: {analysis['congestion']:.2f} min, Slow Move: {analysis['slow_move']:.2f} min, Category: {analysis['category']}")

      # Plotting would go here if needed (matplotlib)
    else:
      print("Could not retrieve travel times for all time slots.")
  else:
    print("Could not retrieve baseline travel time.")


if __name__ == "__main__":
    main()

