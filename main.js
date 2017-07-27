require('NSURL');

defineClass('MerusutoChristina.DataManager', {}, {
    getGithubURL: function(key) {
        var path = "https://merusuto.github.io/data/";
        return NSURL.URLWithString(path).URLByAppendingPathComponent(key);
    }
})
