#!/bin/bash
while sleep 1; do make | grep -v "make: Nothing to be done for"; done
