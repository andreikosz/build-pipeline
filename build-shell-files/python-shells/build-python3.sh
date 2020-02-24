if ! (cd app-folder && mv ./*.py ./backend.py);then
    echo "Could not move python file" && exit 1
else
    echo "Python file successfuly added"
fi