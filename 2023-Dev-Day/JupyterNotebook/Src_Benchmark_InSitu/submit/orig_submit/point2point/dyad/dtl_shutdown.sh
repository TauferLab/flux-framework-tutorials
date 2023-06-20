#!/bin/bash

flux exec -r all flux module unload dyad

flux kvs namespace remove $KVS_NAMESPACE
