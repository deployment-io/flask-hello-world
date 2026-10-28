FROM python:3.12-slim

WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install dependencies first so they're cached when only the code changes.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN useradd --create-home app
USER app
EXPOSE 8000
# Gunicorn listens on 127.0.0.1 unless told otherwise; bind every interface so
# the load balancer can reach it.
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
