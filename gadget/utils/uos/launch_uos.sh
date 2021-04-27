#!/bin/bash
# Copyright (C) 2021 Intel Corporation.
# SPDX-License-Identifier: BSD-3-Clause

uosdir=$SNAP_COMMON/uos

options="Quit"
for img in $uosdir/*.img; do
    [ -e "$img" ] || continue
    options="$options $(basename $img)"
done

PS3="Which User VM to launch? "
select choice in $options; do
    if [ "$choice" != "Quit" ]; then
        [ -e $uosdir/launch_${choice%.img}.sh ] && . $uosdir/launch_${choice%.img}.sh
    fi
    break
done
