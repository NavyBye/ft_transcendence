// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from '@rails/ujs';
import _ from 'underscore';
import $ from 'jquery/src/jquery';
import jquery from 'jquery';
import 'bootstrap';
import app from '../srcs/app';

_.extend($, jquery);

window.$ = $;
window.jquery = $;

Rails.start();
app.start();
