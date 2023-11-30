# Use an official Python runtime as a base image
FROM python:3.9

# Set environment variables for PostgreSQL
ENV POSTGRES_USER=moodleuser
ENV POSTGRES_PASSWORD=your_password
ENV POSTGRES_DB=moodle

# Set the working directory inside the container
WORKDIR /app

# Copy the local requirements.txt to the container
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the local code to the container
COPY . .

# Expose the port your app runs on (adjust as needed)
EXPOSE 8000

# Run migrations and start the application
CMD ["python", "manage.py", "migrate", "&&", "python", "manage.py", "runserver", "0.0.0.0:8000"]
