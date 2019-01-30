import './main.css'
const { Elm } = require('./App.elm');
const createVirtualAudioGraph = require('virtual-audio-graph');

window.AudioContext = window.AudioContext || window.webkitAudioContext;
if (typeof window.AudioContext === 'undefined') {
  alert('Sorry, this browser does not support the Web Audio API.');
}

const root = document.getElementById('root');
var app = Elm.App.init({
  node: root
});

const audioContext = new AudioContext();
const virtualAudioGraph = createVirtualAudioGraph({
  audioContext: audioContext,
  output: audioContext.destination
});

app.ports.renderContextJs.subscribe(function(graph) {
  virtualAudioGraph.update(graph);
});
