# Base image
FROM python:3.8-slim

# Set the working directory
WORKDIR /app

# Copy the local code to the container
COPY . /app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set the command to run the app
CMD ["python", "app.py"]

# Expose the application port
EXPOSE 5000