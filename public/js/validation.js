const form = document.getElementById('form');
const username = document.getElementById('username');
const email = document.getElementById('email');
const password = document.getElementById('password');
const password2 = document.getElementById('password2');
const question = document.getElementById('question');
const answer = document.getElementById('answer');


// patterns for a valid email and password
function isEmail(email) {
	return /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(email);
}

function isPassword(password) {
	return /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9])(?!.*\s).{8,25}$/.test(password);
}




//Created error class
//show alert message and change format - see:changePassword.css


function setErrorFor(input, alert) {
	//parentElement=form-group
	const formGroup = input.parentElement;
	const small = formGroup.querySelector('small');
	formGroup.className = 'form-group error';
	
	//alert message inside <small>
	small.innerText = alert;
}


//Created Valid class
//show validatioon by changingformat

function setValidFor(input) {
	const formGroup = input.parentElement;
	formGroup.className = 'form-group valid';
}




// to enable reusing form
form.addEventListener('submit', (e) => {
	e.preventDefault();
	
	inputValid();
});



//function checking input fields
function inputValid() {
	
	//all values whitespace is trimmed excxept passwords and answer

	const usernameValue = username.value.trim();
	const emailValue = email.value.trim();
	const passwordValue = password.value;
	const password2Value = password2.value;
	const questionValue = question.value.trim();
	const answerValue = answer.value;

	//Username Validation
	
	if(usernameValue === '') {
		setErrorFor(username, 'Username cannot be blank');
	}
	else if (usernameValue.length < 5 || usernameValue.length > 50 ) {
		setErrorFor(username, 'Username character must be 5 to 50 characters');
	}
	else {
		setValidFor(username);
	}
	
	//Email Validation
	if(emailValue === '') {
		setErrorFor(email, 'Email cannot be blank');
	} 
	else if (!isEmail(emailValue)) {
		setErrorFor(email, 'Not a valid email');
	} 
	else {
		setValidFor(email);
	}
	
	
	//Password Validation
	if(passwordValue === '') {
		setErrorFor(password, 'Password cannot be blank');
	} 
	else if (!isPassword(passwordValue)) {
		setErrorFor(password, 'Password length should be between 8 to 25 characters and must contain a lowercase letter, an uppercase letter, a number and a special character ');
	}
	else {
		setValidFor(password);
	}
	
	
	//Password Confirm Validation
	if(password2Value === '') {
		setErrorFor(password2, 'Password confirmation cannot be blank');
	} 
	else if(passwordValue !== password2Value) {
		setErrorFor(password2, 'Passwords do not match');
	} 
	else{
		setValidFor(password2);
	}
	
	
	//question Validation
	if(questionValue === '') {
		setErrorFor(question, 'Please select a question');
	} 
	else{
		setValidFor(question);
	}
	
	
	//Answer Validation
	if(answerValue === '') {
		setErrorFor(answer, 'Answer cannot be blank');
	}
	else if (answerValue.length < 5 || answerlength > 50 ) {
		setErrorFor(answer, 'Answer must be 5 to 50 characters');
	}
	else {
		setValidFor(answer);
	}
	

}