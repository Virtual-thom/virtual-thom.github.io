function debounce(callback, delay) {
  var timer;
  return function () {
    var args = arguments;
    var context = this;
    clearTimeout(timer);
    timer = setTimeout(function () {
      callback.apply(context, args);
    }, delay)
  }
}

function throttle(callback, delay) {
  var last;
  var timer;
  return function () {
    var context = this;
    var now = +new Date();
    var args = arguments;
    if (last && now < last + delay) {
      // le délai n'est pas écoulé on reset le timer
      clearTimeout(timer);
      timer = setTimeout(function () {
        last = now;
        callback.apply(context, args);
      }, delay);
    }
    else {
      last = now;
      callback.apply(context, args);
    }
  };
}
/**
 * Permet de lire un fichier d'input[type="file"]
 * @param {HTMLElement} input 
 * @param {Function} callback 
 */
function readFile(input, callback) {
  if (typeof FileReader !== 'undefined') {
    var fr = new FileReader();
    fr.readAsText(input.files[0]);
    fr.onload = function () {
      callback(fr.result);
    };
  } else if (typeof ActiveXObject !== 'undefined') {
    var path = input.value,
      ts = (new ActiveXObject("Scripting.FileSystemObject")).GetFile(path).OpenAsTextStream(1, -2),
      res = '';
    while (!ts.AtEndOfStream) {
      res += ts.ReadLine() + '\n';
    }
    ts.Close();
    callback(res);
  }
}

// The download function takes a CSV string, the filename and mimeType as parameters
// Scroll/look down at the bottom of this snippet to see how download is called
// Pour avoir les accents et télécharger en CSV lisible par Excel, il faut rajouter le BOM dans content
//  ex. downloadFileJS('\ufeff' + rowTabs.join("\r\n").replace(/,/g, ";"), "lastexecvtom.csv", 'text/csv;charset:utf-8');
var downloadFileJS = function (content, fileName, mimeType) {
  var a = document.createElement('a');
  mimeType = mimeType || 'application/octet-stream';

  if (navigator.msSaveBlob) { // IE10
    navigator.msSaveBlob(new Blob([content], {
      type: mimeType
    }), fileName);
  }
  else if (URL && 'download' in a) { //html5 A[download]
    a.href = URL.createObjectURL(new Blob([content], {
      type: mimeType
    }));
    a.setAttribute('download', fileName);
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
  }
  else {
    location.href = 'data:' + mimeType + ',\ufeff' + encodeURIComponent(content); 
  }
}

// XMLHttpRequest Promesify // TODO remplacer par fetch()
let allRequests = new Array()
let request = obj => {
  return new Promise((resolve, reject) => {
    let xhr = new XMLHttpRequest();
    allRequests.push(xhr)
    xhr.responseType = obj.responseType || 'json'
    xhr.open(obj.method || "GET", obj.url);
    if (obj.headers) {
      Object.keys(obj.headers).forEach(key => {
        xhr.setRequestHeader(key, obj.headers[key]);
      });
    }
    xhr.onload = () => {
      if (xhr.status >= 200 && xhr.status < 300) {
        resolve(xhr.response);
      } else {
        reject(xhr.statusText);
      }
    };
    xhr.onerror = () => reject(xhr.statusText);
    xhr.send(obj.body);
  });
};

// Random Index moins un tableau d'index qu'on fournit en entrée
function getRandomIndex(usedIndexs, maxIndex) {
  var result = 0;
  var min = 0;
  var max = maxIndex - 1;
  var index = Math.floor(Math.random() * (max - min + 1) + min);

  while (usedIndexs.indexOf(index) > -1) {
    if (index < max) {
      index++;
    } else {
      index = 0;
    }
  }

  return index;
}

// FormData to Object
window.formDataToObject = formData => {
  //function formDataToObject(formData){
  let o = {}
  Array.from(formData.keys()).filter((v, k, a) => a.indexOf(v) == k).forEach(k => o[k] = formData.getAll(k))
  return o
}
