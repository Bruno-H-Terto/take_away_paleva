// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "popper"
import "bootstrap"
import "./controllers/main"

import { ola } from "./controllers/main";
window.ola = ola;
import { showModal } from "./controllers/main";
window.showModal = showModal;
import { closeModal } from "./controllers/main";
window.closeModal = closeModal;

import { company_mask } from "./controllers/company_registration_number";
window.company_mask = company_mask;