#!/bin/bash
# Mock chezmoi template variables
USER_NAME="Alice Smith"
USER_EMAIL="alice@example.com"

cp base.docx output.docx
officecli set output.docx / --prop find="{{ NAME }}" --prop replace="$USER_NAME"
officecli set output.docx / --prop find="{{ EMAIL }}" --prop replace="$USER_EMAIL"
officecli close output.docx
