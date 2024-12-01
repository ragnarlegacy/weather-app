# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any required dependencies
RUN pip install --no-cache-dir -r requirements.txt

#Run as non-root user
USER 1000

# Expose the port that the app runs on
EXPOSE 8000

# Command to run the application
CMD ["python", "app.py"]
