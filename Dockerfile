# Use a lightweight python image
FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /app

# Install system dependencies needed for XGBoost/Scikit-Learn (e.g. libgomp1 for openmp)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements file first to leverage Docker build cache
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy all project files into the container
COPY . .

# Expose the default port (Render overrides this dynamically with $PORT)
EXPOSE 5050

# Run using gunicorn, dynamically binding to the port set by Render (or 5050 if unset)
CMD ["sh", "-c", "gunicorn --bind 0.0.0.0:${PORT:-5050} app:app"]
