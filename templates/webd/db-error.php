<?php 
  header('HTTP/1.1 {{ item.error_code }} {{ item.error_name }}');
  header('Status: {{ item.error_code }} {{ item.error_name }}');
  header('Retry-After: 600'); // 1 hour = 3600 seconds
?>

{% include "error.html" %}
