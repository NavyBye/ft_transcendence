// module 폴더(.)에 있는 모든 js 파일 로드, 하위폴더는 없으므로 false.
const modules = require.context('.', false, /\.js$/);

const model = {};

modules.keys().forEach(filename => {
  if (filename !== './index.js') {
    const moduleName = filename.replace(/(\.\/|\.js)/g, '');
    model[moduleName] = modules(filename).default;
  }
});

export default model;
