#!/bin/perl

# Trivial script to record any call coming to this number
# In SkyPE, can conference this number in and get automatic recording

print << "MARK";
Content-type: text/xml

<?xml version="1.0" encoding="UTF-8"?>
<Response><Record time_limit="3600" /></Response>
MARK
;
