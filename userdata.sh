#!/bin/bash

# Update system
yum update -y

# Install required packages
yum install -y httpd aws-cli amazon-cloudwatch-agent

# Get instance metadata
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
AVAILABILITY_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/region)
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

# Create application directory structure
mkdir -p /var/www/html/{css,js,images}

# Create enhanced HTML content
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${project_name} - DevOps Portfolio</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <header>
            <h1><i class="fas fa-cloud"></i> DevOps Portfolio Project</h1>
            <p class="subtitle">Scalable Infrastructure with Auto Scaling & Load Balancing</p>
        </header>
        
        <div class="info-grid">
            <div class="info-card">
                <h3><i class="fas fa-server"></i> Instance Details</h3>
                <p><strong>Instance ID:</strong> <span class="highlight">$INSTANCE_ID</span></p>
                <p><strong>Availability Zone:</strong> <span class="highlight">$AVAILABILITY_ZONE</span></p>
                <p><strong>Private IP:</strong> <span class="highlight">$PRIVATE_IP</span></p>
                <p><strong>Region:</strong> <span class="highlight">$REGION</span></p>
            </div>
            
            <div class="info-card">
                <h3><i class="fas fa-cogs"></i> Infrastructure</h3>
                <p><strong>Project:</strong> ${project_name}</p>
                <p><strong>Environment:</strong> ${environment}</p>
                <p><strong>Load Balanced:</strong> ✓ Yes</p>
                <p><strong>Auto Scaling:</strong> ✓ Enabled</p>
            </div>
            
            <div class="info-card">
                <h3><i class="fas fa-chart-line"></i> Monitoring</h3>
                <p><strong>CloudWatch:</strong> ✓ Active</p>
                <p><strong>Health Checks:</strong> ✓ Passing</p>
                <p><strong>Logging:</strong> ✓ Enabled</p>
                <p><strong>Alerts:</strong> ✓ Configured</p>
            </div>
            
            <div class="info-card">
                <h3><i class="fas fa-shield-alt"></i> Security</h3>
                <p><strong>VPC:</strong> ✓ Private Subnets</p>
                <p><strong>Security Groups:</strong> ✓ Configured</p>
                <p><strong>Bastion Host:</strong> ✓ Available</p>
                <p><strong>SSL Ready:</strong> ✓ Supported</p>
            </div>
        </div>
        
        <div class="tech-stack">
            <h3><i class="fas fa-tools"></i> Technology Stack</h3>
            <div class="tech-badges">
                <span class="badge">Terraform</span>
                <span class="badge">AWS</span>
                <span class="badge">Auto Scaling</span>
                <span class="badge">Load Balancer</span>
                <span class="badge">CloudWatch</span>
                <span class="badge">VPC</span>
                <span class="badge">S3</span>
                <span class="badge">IAM</span>
                <span class="badge">EC2</span>
            </div>
        </div>
        
        <footer>
            <p>&copy; 2025 ${project_name}. All rights reserved.</p>
            <p>Deployed on AWS with Terraform</p>
        </footer>
    </div>
</body>
</html>
EOF

# Create CSS styles
cat <<EOF > /var/www/html/css/style.css
body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
    background-color: #f4f4f9;
    color: #333;
}

.container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
}

header {
    text-align: center;
    padding: 40px 0;
    background: linear-gradient(135deg, #1e3c72, #2a5298);
    color: white;
    border-radius: 8px;
    margin-bottom: 20px;
}

header h1 {
    margin: 0;
    font-size: 2.5em;
}

header .subtitle {
    margin: 10px 0 0;
    font-size: 1.2em;
    opacity: 0.8;
}

.info-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 20px;
    margin-bottom: 40px;
}

.info-card {
    background: white;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    transition: transform 0.2s;
}

.info-card:hover {
    transform: translateY(-5px);
}

.info-card h3 {
    margin: 0 0 15px;
    font-size: 1.4em;
    color: #2a5298;
}

.info-card p {
    margin: 5px 0;
    line-height: 1.6;
}

.highlight {
    color: #e44d26;
    font-weight: bold;
}

.tech-stack {
    text-align: center;
    margin-bottom: 40px;
}

.tech-stack h3 {
    margin-bottom: 20px;
    font-size: 1.8em;
    color: #2a5298;
}

.tech-badges .badge {
    display: inline-block;
    background: #2a5298;
    color: white;
    padding: 8px 15px;
    margin: 5px;
    border-radius: 15px;
    font-size: 0.9em;
}

footer {
    text-align: center;
    padding: 20px 0;
    background: #1e3c72;
    color: white;
    border-radius: 8px;
}

footer p {
    margin: 5px 0;
}

@media (max-width: 768px) {
    .container {
        padding: 10px;
    }
    
    header h1 {
        font-size: 2em;
    }
    
    .info-card {
        padding: 15px;
    }
}
EOF

# Create health check endpoint
cat <<EOF > /var/www/html/health
OK
EOF

# Configure CloudWatch Agent
cat <<EOF > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "agent": {
    "metrics_collection_interval": 60,
    "logfile": "/var/log/amazon-cloudwatch-agent.log"
  },
  "metrics": {
    "namespace": "${project_name}/WebServer",
    "metrics_collected": {
      "cpu": {
        "measurement": [
          "cpu_usage_idle",
          "cpu_usage_iowait",
          "cpu_usage_user",
          "cpu_usage_system"
        ],
        "metrics_collection_interval": 60
      },
      "disk": {
        "measurement": [
          "used_percent",
          "inodes_free"
        ],
        "metrics_collection_interval": 60,
        "resources": [
          "/"
        ]
      },
      "mem": {
        "measurement": [
          "mem_used_percent"
        ],
        "metrics_collection_interval": 60
      }
    },
    "append_dimensions": {
      "InstanceId": "$INSTANCE_ID",
      "AutoScalingGroupName": "${project_name}-asg"
    }
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/httpd/access_log",
            "log_group_name": "/aws/ec2/${project_name}",
            "log_stream_name": "{instance_id}/access_log"
          },
          {
            "file_path": "/var/log/httpd/error_log",
            "log_group_name": "/aws/ec2/${project_name}",
            "log_stream_name": "{instance_id}/error_log"
          }
        ]
      }
    }
  }
}
EOF

# Start and enable services
systemctl enable httpd
systemctl start httpd
systemctl enable amazon-cloudwatch-agent
systemctl start amazon-cloudwatch-agent

# Set proper permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

# Sync assets from S3 (if any)
aws s3 sync s3://${bucket_name}/ /var/www/html/ --region $REGION

# Create startup script to ensure services are running
cat <<EOF > /etc/rc.local
#!/bin/bash
systemctl start httpd
systemctl start amazon-cloudwatch-agent
EOF
chmod +x /etc/rc.local