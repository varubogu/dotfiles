#!/bin/bash

echo "locale to japan ..."

sudo update-locale LANG=ja_JP.UTF8
sudo timedatectl set-timezone Asia/Tokyo

