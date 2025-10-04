"""Holds the version for Archipelago."""
import json

version = ""

try:
    with open('archipelago.json', 'r') as manifest:
        data = json.load(manifest)
        version = data['world_version']
except FileNotFoundError:
    print("Error: The file 'archipelago.json' was not found.")
except json.JSONDecodeError:
    print("Error: Could not decode JSON from 'archipelago.json'.")