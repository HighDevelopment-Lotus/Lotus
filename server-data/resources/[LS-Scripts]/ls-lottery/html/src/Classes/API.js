class API {

  constructor () {
    window.addEventListener('message', (event) => {
      const eventType = event.data.event
      if (eventType !== undefined && typeof this['on' + eventType] === 'function') {
        this['on' + eventType](event.data)
      }
    });

    this.config = null
  }

  cageFetch( endpoint, body ) {

    var args = {
      method: 'POST',
      mode: 'cors',
      cache: 'no-cache',
      headers: {
        'Content-Type': 'application/json',
      //  'Accept': 'application/json, application/xml, text/plain, text/html, *.*',
      // 'Accept': 'application/json',
      // 'Content-Type': 'application/json'
      }
    }

    if(body != null) {
      args['body'] = body;
    }

    return fetch('http://ls-lottery/'+endpoint, args);

  }

  async post (method, data) {
    const ndata = data === undefined ? '{}' : JSON.stringify(data);
    //const response = await window.jQuery.post(BASE_URL + method, ndata);

    var response = {}

    try {
      response = await this.cageFetch(method, ndata);
    }catch(err) {
      console.log("ERROR: "+err);
    }

    return response;
    //return JSON.parse(response);
  }

  async log (...data) {
    if (process.env.NODE_ENV === 'production') {
      return this.post('log', data);
    } else {
      return console.log(...data);
    }
  }

  async cardClosed () {
    return this.post('cs:cardClosed', {});
  }

  async onOpenCard (data) {
    window.dispatchEvent(new CustomEvent('cagescratchShow', {'detail': {'blocks': {'block1': data.block1, 'block2': data.block2, 'block3': data.block3}, 'serial': data.serial } } ));
  }

  async onCloseCard() {
    window.dispatchEvent(new CustomEvent('cagescratchHide', {'detail': {} } ));
  }

}

const instance = new API()

export default instance;
