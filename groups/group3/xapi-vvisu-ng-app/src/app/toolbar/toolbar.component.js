import { module } from 'angular';
import template from './toolbar.component.html';
import './toolbar.component.scss';

class ToolbarController {

    constructor($log, $rootScope, $scope, $state) {
        'ngInject'
        this.$log = $log.getInstance(ToolbarController.name);
    }

    log(...msg) {
        this.$log.debug(...msg);
    }

}

const ToolbarComponent = {
    template,
    restricted: 'E',
    controllerAs: 'toolbar',
    controller: ToolbarController,
};

export default module('app.toolbar', [])
    .component('toolbar', ToolbarComponent);