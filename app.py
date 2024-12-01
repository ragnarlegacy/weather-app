from flask import Flask, request, jsonify, render_template
import requests
from flask_caching import Cache

class WeatherApp:
    def __init__(self):
        self.app = Flask(__name__, template_folder="templates", static_folder="static")
        self.app.config['CACHE_TYPE'] = 'SimpleCache'  
        self.app.config['CACHE_DEFAULT_TIMEOUT'] = 300 
        self.cache = Cache(self.app)
        self.api_key = "84cc9d23bb9571cdd3f0a5f0720fe802"  # Replace with your OpenWeatherMap API key
        self.configure_routes()

    def configure_routes(self):
        @self.app.route('/', methods=['GET'])
        def index():
            return render_template("index.html")
        
        @self.app.route('/get_temperature', methods=['GET'])
        def get_temperature():
            city = request.args.get('city')
            if not city:
                return jsonify({"error": "City name is required!"}), 400
            
            cache_key = f"weather_{city.lower()}"
            cached_response = self.cache.get(cache_key)
            
            if cached_response:
                # Return cached response
                return jsonify(cached_response)
            
            try:
                # Fetch data from OpenWeatherMap API
                url = f"http://api.openweathermap.org/data/2.5/weather?q={city}&units=metric&appid={self.api_key}"
                response = requests.get(url)
                data = response.json()

                if response.status_code == 200:
                    temperature = data['main']['temp']
                    return jsonify({
                        "city": city,
                        "temperature": f"{temperature}°C",
                        "message": f"The current temperature in {city} is {temperature}°C."
                    })
                    self.cache.set(cache_key, result)
                    return jsonify(result)
                else:
                    return jsonify({"error": data.get("message", "Something went wrong!")}), 400
            except Exception as e:
                return jsonify({"error": str(e)}), 500

    def run(self, debug=True, port=8000):
        self.app.run(debug=debug, port=port)

# Entry point for the application
if __name__ == '__main__':
    weather_app = WeatherApp()
    weather_app.run(debug=True, port=8000)
    

