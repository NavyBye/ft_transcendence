import $ from 'jquery/src/jquery';

const auth = {
  getTokenKey() {
    return $('meta[name=csrf-param]').attr('content');
  },
  getTokenValue() {
    return $('meta[name=csrf-token]').attr('content');
  },
};

export default auth;
