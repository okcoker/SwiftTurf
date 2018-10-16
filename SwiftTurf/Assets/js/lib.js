"use strict"
var buffer = require('@turf/buffer')
var contains = require('@turf/boolean-contains')
var destination = require('@turf/destination')
var kinks = require('@turf/kinks')
var lineIntersect = require('@turf/line-intersect')

global.buffer = buffer
global.contains = contains
global.destination = destination
global.kinks = kinks
global.lineIntersect = lineIntersect
