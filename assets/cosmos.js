(function () {
  'use strict';

  var container = document.getElementById('cosmos-canvas');
  if (!container) return;

  var vertexSource = [
    'attribute vec2 position;',
    'varying vec2 vUv;',
    'void main() {',
    '  vUv = position * 0.5 + 0.5;',
    '  gl_Position = vec4(position, 0.0, 1.0);',
    '}'
  ].join('\n');

  /* Keep the original 287c83b/5c3b06c starfield shader unchanged. */
  var fragmentSource = [
    'precision highp float;',
    'uniform float uTime;',
    'uniform vec3 uResolution;',
    'uniform vec2 uMouse;',
    'uniform float uMouseActive;',
    'varying vec2 vUv;',
    '',
    '#define NUM_LAYER 4.0',
    '#define MAT45 mat2(0.7071, -0.7071, 0.7071, 0.7071)',
    '',
    'float Hash21(vec2 p) {',
    '  p = fract(p * vec2(123.34, 456.21));',
    '  p += dot(p, p + 45.32);',
    '  return fract(p.x * p.y);',
    '}',
    '',
    'float tri(float x) {',
    '  return abs(fract(x) * 2.0 - 1.0);',
    '}',
    '',
    'float tris(float x) {',
    '  return 1.0 - smoothstep(0.0, 1.0, abs(2.0 * fract(x) - 1.0));',
    '}',
    '',
    'float trisn(float x) {',
    '  return 2.0 * (1.0 - smoothstep(0.0, 1.0, abs(2.0 * fract(x) - 1.0))) - 1.0;',
    '}',
    '',
    'float Star(vec2 uv, float flare) {',
    '  float d = length(uv);',
    '  float m = 0.02 / d;',
    '  float rays = smoothstep(0.0, 1.0, 1.0 - abs(uv.x * uv.y * 1000.0));',
    '  m += rays * flare * 0.35;',
    '  uv *= MAT45;',
    '  rays = smoothstep(0.0, 1.0, 1.0 - abs(uv.x * uv.y * 1000.0));',
    '  m += rays * 0.1 * flare;',
    '  m *= smoothstep(1.0, 0.2, d);',
    '  return m;',
    '}',
    '',
    'vec3 StarLayer(vec2 uv) {',
    '  vec3 col = vec3(0.0);',
    '  vec2 gv = fract(uv) - 0.5;',
    '  vec2 id = floor(uv);',
    '  for (int y = -1; y <= 1; y++) {',
    '    for (int x = -1; x <= 1; x++) {',
    '      vec2 offset = vec2(float(x), float(y));',
    '      vec2 si = id + offset;',
    '      float seed = Hash21(si);',
    '      float size = fract(seed * 345.32);',
    '      float glossLocal = tri(uTime * 0.03 / (3.0 * seed + 1.0));',
    '      float flareSize = smoothstep(0.9, 1.0, size) * glossLocal;',
    '      float bright = 0.7 + 0.3 * Hash21(si + 1.0);',
    '      float temp = Hash21(si + 2.0);',
    '      vec3 base = mix(vec3(0.8, 0.85, 1.0), vec3(1.0, 0.95, 0.85), temp);',
    '      base *= bright;',
    '      vec2 pad = vec2(',
    '        tris(seed * 34.0 + uTime * 0.03),',
    '        tris(seed * 38.0 + uTime * 0.01)',
    '      ) - 0.5;',
    '      float star = Star(gv - offset - pad, flareSize);',
    '      float twinkle = trisn(uTime * 0.3 + seed * 6.2831) * 0.5 + 1.0;',
    '      twinkle = mix(1.0, twinkle, 0.4);',
    '      star *= twinkle;',
    '      col += star * size * base;',
    '    }',
    '  }',
    '  return col;',
    '}',
    '',
    'void main() {',
    '  vec2 uv = (vUv * uResolution.xy - 0.5 * uResolution.xy) / uResolution.y;',
    '  vec2 mouseOffset = (uMouse - vec2(0.5)) * 0.08 * uMouseActive;',
    '  uv += mouseOffset;',
    '  float angle = uTime * 0.03;',
    '  mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));',
    '  uv = rot * uv;',
    '  vec3 col = vec3(0.0);',
    '  for (float i = 0.0; i < 1.0; i += 1.0 / NUM_LAYER) {',
    '    float depth = fract(i + uTime * 0.03);',
    '    float scale = mix(20.0, 0.5, depth);',
    '    float fade = depth * smoothstep(1.0, 0.9, depth);',
    '    col += StarLayer(uv * scale + i * 453.32) * fade;',
    '  }',
    '  gl_FragColor = vec4(col, 1.0);',
    '}'
  ].join('\n');

  var canvas = document.createElement('canvas');
  container.appendChild(canvas);

  var contextOptions = {
    alpha: false,
    antialias: false,
    depth: false,
    stencil: false,
    premultipliedAlpha: false,
    preserveDrawingBuffer: false,
    powerPreference: 'low-power'
  };
  var gl = canvas.getContext('webgl', contextOptions) ||
    canvas.getContext('experimental-webgl', contextOptions);

  if (!gl) {
    canvas.remove();
    return;
  }

  function compileShader(type, source) {
    var shader = gl.createShader(type);
    gl.shaderSource(shader, source);
    gl.compileShader(shader);
    if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
      var message = gl.getShaderInfoLog(shader) || 'Unknown shader compilation error';
      gl.deleteShader(shader);
      throw new Error(message);
    }
    return shader;
  }

  var program;
  var vertexShader;
  var fragmentShader;

  try {
    vertexShader = compileShader(gl.VERTEX_SHADER, vertexSource);
    fragmentShader = compileShader(gl.FRAGMENT_SHADER, fragmentSource);
    program = gl.createProgram();
    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);

    if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
      throw new Error(gl.getProgramInfoLog(program) || 'Unknown WebGL link error');
    }
  } catch (error) {
    if (program) gl.deleteProgram(program);
    if (vertexShader) gl.deleteShader(vertexShader);
    if (fragmentShader) gl.deleteShader(fragmentShader);
    canvas.remove();
    return;
  }

  gl.deleteShader(vertexShader);
  gl.deleteShader(fragmentShader);
  gl.useProgram(program);

  var buffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
  gl.bufferData(
    gl.ARRAY_BUFFER,
    new Float32Array([-1, -1, 3, -1, -1, 3]),
    gl.STATIC_DRAW
  );

  var position = gl.getAttribLocation(program, 'position');
  gl.enableVertexAttribArray(position);
  gl.vertexAttribPointer(position, 2, gl.FLOAT, false, 0, 0);

  var timeUniform = gl.getUniformLocation(program, 'uTime');
  var resolutionUniform = gl.getUniformLocation(program, 'uResolution');
  var mouseUniform = gl.getUniformLocation(program, 'uMouse');
  var mouseActiveUniform = gl.getUniformLocation(program, 'uMouseActive');

  var mobileQuery = window.matchMedia('(max-width: 640px), (pointer: coarse)');
  var finePointerQuery = window.matchMedia('(pointer: fine)');
  var reducedMotionQuery = window.matchMedia('(prefers-reduced-motion: reduce)');
  var profile = null;
  var cssWidth = 1;
  var cssHeight = 1;
  var animationTime = 0;
  var lastTimestamp = 0;
  var lastDrawTimestamp = 0;
  var frameRequest = 0;
  var resizeTimer = 0;
  var running = false;
  var contextLost = false;
  var mouse = { x: 0.5, y: 0.5 };
  var target = { x: 0.5, y: 0.5 };
  var mouseActive = 0;
  var mouseActiveTarget = 0;

  function selectProfile() {
    profile = mobileQuery.matches
      ? { scale: 0.55, maxPixels: 250000, fps: 18 }
      : { scale: 0.70, maxPixels: 900000, fps: 24 };
  }

  function resizeCanvas(force) {
    cssWidth = Math.max(1, container.clientWidth || window.innerWidth || 1);
    cssHeight = Math.max(1, container.clientHeight || window.innerHeight || 1);

    var pixelLimitScale = Math.sqrt(profile.maxPixels / (cssWidth * cssHeight));
    var renderScale = Math.min(profile.scale, pixelLimitScale);
    var width = Math.max(1, Math.round(cssWidth * renderScale));
    var height = Math.max(1, Math.round(cssHeight * renderScale));

    if (!force && canvas.width === width && canvas.height === height) return;
    canvas.width = width;
    canvas.height = height;
    gl.viewport(0, 0, width, height);
  }

  function draw(timestamp) {
    if (contextLost) return;

    var frameSeconds = 1 / profile.fps;
    var elapsed = lastTimestamp
      ? Math.min((timestamp - lastTimestamp) * 0.001, 0.25)
      : frameSeconds;
    lastTimestamp = timestamp;
    animationTime += elapsed;

    var smoothing = 1 - Math.exp(-3.078 * elapsed);
    mouse.x += (target.x - mouse.x) * smoothing;
    mouse.y += (target.y - mouse.y) * smoothing;
    mouseActive += (mouseActiveTarget - mouseActive) * smoothing;

    gl.uniform1f(timeUniform, animationTime);
    gl.uniform3f(resolutionUniform, cssWidth, cssHeight, cssWidth / cssHeight);
    gl.uniform2f(mouseUniform, mouse.x, mouse.y);
    gl.uniform1f(mouseActiveUniform, mouseActive);
    gl.drawArrays(gl.TRIANGLES, 0, 3);
  }

  function frame(timestamp) {
    if (!running) return;
    frameRequest = window.requestAnimationFrame(frame);

    var interval = 1000 / profile.fps;
    if (lastDrawTimestamp && timestamp - lastDrawTimestamp < interval) return;
    lastDrawTimestamp = timestamp;
    draw(timestamp);
  }

  function stop() {
    running = false;
    if (frameRequest) window.cancelAnimationFrame(frameRequest);
    frameRequest = 0;
    lastTimestamp = 0;
    lastDrawTimestamp = 0;
  }

  function start() {
    if (running || contextLost || document.hidden || reducedMotionQuery.matches) return;
    running = true;
    lastTimestamp = 0;
    lastDrawTimestamp = 0;
    frameRequest = window.requestAnimationFrame(frame);
  }

  function renderStillFrame() {
    stop();
    draw(window.performance.now());
  }

  function updateMotionState() {
    if (document.hidden) {
      stop();
    } else if (reducedMotionQuery.matches) {
      renderStillFrame();
    } else {
      start();
    }
  }

  function handleProfileChange() {
    selectProfile();
    resizeCanvas(true);
    updateMotionState();
  }

  function addMediaListener(query, handler) {
    if (query.addEventListener) {
      query.addEventListener('change', handler);
    } else if (query.addListener) {
      query.addListener(handler);
    }
  }

  selectProfile();
  resizeCanvas(true);

  if (finePointerQuery.matches) {
    document.addEventListener('pointermove', function (event) {
      target.x = event.clientX / Math.max(1, window.innerWidth);
      target.y = 1 - event.clientY / Math.max(1, window.innerHeight);
      mouseActiveTarget = 1;
    }, { passive: true });

    document.addEventListener('pointerleave', function () {
      mouseActiveTarget = 0;
    }, { passive: true });

    window.addEventListener('blur', function () {
      mouseActiveTarget = 0;
    });
  }

  window.addEventListener('resize', function () {
    window.clearTimeout(resizeTimer);
    resizeTimer = window.setTimeout(function () {
      selectProfile();
      resizeCanvas(false);
    }, 150);
  }, { passive: true });

  document.addEventListener('visibilitychange', updateMotionState);
  window.addEventListener('pagehide', stop);
  window.addEventListener('pageshow', updateMotionState);
  addMediaListener(mobileQuery, handleProfileChange);
  addMediaListener(reducedMotionQuery, updateMotionState);

  canvas.addEventListener('webglcontextlost', function (event) {
    event.preventDefault();
    contextLost = true;
    stop();
  });

  if (reducedMotionQuery.matches) {
    renderStillFrame();
  } else {
    start();
  }
})();
