#!/usr/bin/env python2.7
# -*- coding: utf-8 -*-
# TODO: Use python3

import dbus
session_bus = dbus.SessionBus()
spotify_bus = session_bus.get_object('org.mpris.MediaPlayer2.spotify',
                                     '/org/mpris/MediaPlayer2')
spotify_properties = dbus.Interface(spotify_bus,
                                    'org.freedesktop.DBus.Properties')
metadata = spotify_properties.Get('org.mpris.MediaPlayer2.Player', 'Metadata')
#for key in spotify_properties.GetAll('org.mpris.MediaPlayer2.Player').keys():
#    print(key)
playing = spotify_properties.Get('org.mpris.MediaPlayer2.Player', 'PlaybackStatus')
#shuffle = spotify_properties.Get('org.mpris.MediaPlayer2.Player', 'Shuffle')
# The property Metadata behaves like a python dict
#for key, value in metadata.items():
#    print(key, value)

print('{icon} {artist} - {title}'.format(icon='▶' if playing == 'Playing' else '||',
                                         artist=metadata['xesam:artist'][0],
                                         title=metadata['xesam:title']))

