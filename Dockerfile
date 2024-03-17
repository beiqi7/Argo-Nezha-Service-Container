FROM ghcr.io/naiba/nezha-dashboard

# Create a non-root user named 'appuser'
RUN useradd -r -u 10014 -g <primary_group_id> appuser

# Expose port 80
EXPOSE 80

# Set the working directory
WORKDIR /dashboard

# Copy files
COPY entrypoint.sh /dashboard/
COPY sqlite.db /dashboard/data/

# Install necessary packages
RUN apt-get update && \
    apt-get -y install openssh-server wget iproute2 vim git cron unzip supervisor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set permissions
RUN chmod +x entrypoint.sh && \
    chown -R appuser:appuser /dashboard

# Switch to the non-root user
USER appuser

# Set entrypoint script executable by the non-root user
ENTRYPOINT ["./entrypoint.sh"]
