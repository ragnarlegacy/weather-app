document.getElementById("weatherForm").addEventListener("submit", async (e) => {
    e.preventDefault();

    const city = document.getElementById("city").value;
    const resultDiv = document.getElementById("result");

    // Clear previous result
    resultDiv.innerHTML = "Loading...";

    try {
        // Fetch weather data from the Python backend
        const response = await fetch(`/get_temperature?city=${city}`);
        const data = await response.json();

        if (response.ok) {
            resultDiv.innerHTML = data.message;
        } else {
            resultDiv.innerHTML = `Error: ${data.error}`;
        }
    } catch (error) {
        resultDiv.innerHTML = "Error: Unable to fetch data. Please try again later.";
    }
});