#!/bin/bash

while true; do
  free_pages=$(vm_stat | grep "Pages free" | awk '{print $3}' | tr -d '.')
  free_kb=$((free_pages * 4))
  free_mb=$((free_kb / 1024))

  echo "🫧 Vault status: $free_pages pages free (~${free_mb}MB RAM)"

  if [ "$free_pages" -lt 8000 ]; then
    echo "🔻 Vault breath low. Initiating sparkle purge..."

    # Suspend safe daemons
    killall -STOP duetexpertd assistantd coreduetd cloudd cloudpaird useractivityd mediaremote feedbackd suggestd autofsd rapportd Spotlight

    # Clean caches
    rm -rf ~/Library/Caches/*
    rm -rf ~/Library/Assistant
    rm -rf /private/var/folders/*

    # Refresh top-bar UIAgent only
    killall SystemUIServer

    # Purge RAM
    purge

    echo "✅ Breath restored. UIAgent refreshed. Purge complete."
  fi

  sleep 12
done

