import "../stylesheets/application"

// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import "channels"

Rails.start()
Turbolinks.start()

import '@fortawesome/fontawesome-free'
import "bootstrap"

// query elements by css selector
const querySelector = (selector, scope = document) => Array.from(scope.querySelectorAll(selector));

document.addEventListener("turbolinks:load", () => {
  // scripts
  querySelector('.search-form').forEach($form => {
    // add Enter event listener to form element
    $form.addEventListener('keyup', e => {
      if (e.code === 'Enter') {
        e.preventDefault()
        $form.submit()
      }
    })

    // add blur event listener to text input elements
    querySelector('input[type=text]', $form).forEach($input => {
      $input.addEventListener('blur', () => $form.submit())
    })

    // add change event listener to date input elements
    querySelector('input[type=date]', $form).forEach($input => {
      $input.addEventListener('change', () => $form.submit())
    })
  })
})
