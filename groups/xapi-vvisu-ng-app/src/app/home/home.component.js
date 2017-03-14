import { module } from 'angular';
import template from './home.component.html';
import './home.component.scss';

class HomeController {

    constructor($log, $state, $stateParams) {
        'ngInject'
        this.$log = $log.getInstance(HomeController.name);
    }

    log(...msg) {
        this.$log.debug(...msg);
    }

    $onInit() {
    }

}

const HomeComponent = {
    template,
    restricted: 'E',
    controllerAs: 'home',
    controller: HomeController,
};

export default module('app.home', [])
    .component('home', HomeComponent);