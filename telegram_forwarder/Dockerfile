# Use an official Python runtime as the base image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy both scripts to the container
COPY telegram_forward.py /app/telegram_forward.py
COPY get_group_ids.py /app/get_group_ids.py

# Install necessary Python packages
RUN pip install telethon

# Create a volume for session persistence
VOLUME ["/app/sessions"]

# Default command to run the forwarding script
CMD ["python", "/app/telegram_forward.py"]
