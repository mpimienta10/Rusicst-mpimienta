app.directive('pwCheck', [function () {
    return {
        require: 'ngModel',
        link: function (scope, elem, attrs, ctrl) {
            var firstPassword = '#' + attrs.pwCheck;
            elem.add(firstPassword).on('keyup', function () {
                scope.$apply(function () {
                    var v = elem.val() === $(firstPassword).val();
                    ctrl.$setValidity('pwmatch', v);
                });
            });
        }
    }
}]);

app.directive('validPwd', [function () {
    return {
        require: 'ngModel',
        link: function (scope, elm, attrs, ctrl) {
            /*ctrl.$parsers.unshift(function (viewValue) {
                console.log(viewValue)
            ctrl.$parsers.unshift(function (viewValue) {
                scope.pwdValidLength = (viewValue && viewValue.length >= 8 ? 'valid' : undefined); // Comprueba la longitud de la cadena.
                scope.pwdHasLetterMay = (viewValue && /[A-Z]/.test(viewValue)) ? 'valid' : undefined; // Compruebe si la cadena contiene letras mayusculas.
                scope.pwdHasLetterMin = (viewValue && /[a-z]/.test(viewValue)) ? 'valid' : undefined; // Compruebe si la cadena contiene letras minusculas.
                scope.pwdHasNumber = (viewValue && /\d/.test(viewValue)) ? 'valid' : undefined; // Compruebe si la cadena contiene dígitos.
                scope.pwdHasCharacter = (viewValue && /[^A-Za-z0-9]/.test(viewValue)) ? 'valid' : undefined; // Compruebe si la cadena contiene caracteres espaciales.

                if (scope.pwdValidLength && scope.pwdHasLetterMay && scope.pwdHasLetterMin && scope.pwdHasNumber && scope.pwdHasCharacter) {
                    ctrl.$setValidity('pwdValid', true); 
                    return viewValue; */
            ctrl.$parsers.unshift(function (viewValue) {
                scope.pwdValidLength = (viewValue && viewValue.length >= 6 ? 'valid' : undefined); // Comprueba la longitud de la cadena.
                scope.pwdHasLetter = (viewValue && /[A-z]/.test(viewValue)) ? 'valid' : undefined; // Compruebe si la cadena contiene letras.
                scope.pwdHasNumber = (viewValue && /\d/.test(viewValue)) ? 'valid' : undefined; // Compruebe si la cadena contiene dígitos.

                if (scope.pwdValidLength && scope.pwdHasLetter && scope.pwdHasNumber) { 
                    ctrl.$setValidity('pwdValid', true); 
                    return viewValue;
                } else { 
                    ctrl.$setValidity('pwdValid', false); 
                    return undefined; 
                }
            });
        }
    };
}]);