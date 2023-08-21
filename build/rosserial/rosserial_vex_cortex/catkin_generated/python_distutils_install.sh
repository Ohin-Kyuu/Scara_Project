#!/bin/sh

if [ -n "$DESTDIR" ] ; then
    case $DESTDIR in
        /*) # ok
            ;;
        *)
            /bin/echo "DESTDIR argument must be absolute... "
            /bin/echo "otherwise python's distutils will bork things."
            exit 1
    esac
fi

echo_and_run() { echo "+ $@" ; "$@" ; }

echo_and_run cd "/home/scara/scara/src/rosserial/rosserial_vex_cortex"

# ensure that Python install destination exists
echo_and_run mkdir -p "$DESTDIR/home/scara/scara/install/lib/python3/dist-packages"

# Note that PYTHONPATH is pulled from the environment to support installing
# into one location when some dependencies were installed in another
# location, #123.
echo_and_run /usr/bin/env \
    PYTHONPATH="/home/scara/scara/install/lib/python3/dist-packages:/home/scara/scara/build/lib/python3/dist-packages:$PYTHONPATH" \
    CATKIN_BINARY_DIR="/home/scara/scara/build" \
    "/usr/bin/python3" \
    "/home/scara/scara/src/rosserial/rosserial_vex_cortex/setup.py" \
     \
    build --build-base "/home/scara/scara/build/rosserial/rosserial_vex_cortex" \
    install \
    --root="${DESTDIR-/}" \
    --install-layout=deb --prefix="/home/scara/scara/install" --install-scripts="/home/scara/scara/install/bin"
