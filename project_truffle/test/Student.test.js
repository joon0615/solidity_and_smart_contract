const Student = artifacts.require('Student')

contract('Student', function(accounts) {
    it('should initially return empty record', function() {
        return Student.deployed().then((instance) => {
            return instance.getStudent();
        }).then((result) => {
            assert.equal(result['0'], ''); // first name
            assert.equal(result['1'], ''); // last name
            assert.equal(result['2'], ''); // birth of date
        });
    });

    var student;
    it('should property add record', function() {
        return Student.deployed().then((instance) => {
            student = instance;
            return student.setStudent('Tom', 'Holland', '06/01/1996');
        }).then((tx) => {
            return student.getStudent();
        }).then((result) => {
            assert.equal(result['0'], 'Tom'); // first name
            assert.equal(result['1'], 'Holland'); // last name
            assert.equal(result['2'], '06/01/1996'); // birth of date
        });
    });
});