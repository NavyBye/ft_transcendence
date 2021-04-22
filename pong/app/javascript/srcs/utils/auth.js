import $ from 'jquery/src/jquery';

const auth = {
  getTokenKey() {
    const originalToken = $('meta[name=csrf-param]').attr('content');
    const myToken = auth.getCookie('my_csrf_token');
    console.log(`my token${myToken}`);
    return myToken || originalToken;
  },
  getTokenValue() {
    return $('meta[name=csrf-token]').attr('content');
  },
  getCookie(name) {
    const cookieName = `${name}=`;
    const cookieData = document.cookie;
    let start = cookieData.indexOf(cookieName);
    let cookieValue = '';
    if (start !== -1) {
      start += cookieName.length;
      let end = cookieData.indexOf(';', start);
      if (end === -1) end = cookieData.length;
      cookieValue = cookieData.substring(start, end);
    }
    return unescape(cookieValue);
  },
};

export default auth;
