const form = document.getElementById('form');
const username = document.getElementById('username');
const firstname = document.getElementById('firstname');
const lastname = document.getElementById('lastname');
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

function isName(name) {
	return /^[A-Za-z.-]+(\s*[A-Za-z.-]+)*$/.test(name);
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
		
	if(!inputValid()){
    e.preventDefault();
  }
});



//function checking input fields
function inputValid() {
	
	//all values whitespace is trimmed except passwords and answer
  const usernameValue = username.value.trim();
	const firstnameValue = firstname.value.trim();
  const lastnameValue = lastname.value.trim();
	const emailValue = email.value.trim();
	const passwordValue = password.value;
	const password2Value = password2.value;
	const questionValue = question.value.trim();
	const answerValue = answer.value;
  var isValid = true;
  
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
  
	//Firstname Validation
	
	if(firstnameValue === '') {
		setErrorFor(firstname, 'Name cannot be blank');
    isValid = false;
	}
  else if (!isName(firstnameValue)) {
		setErrorFor(firstname, 'Not a valid name');
    isValid = false;
	} 
	else if (firstnameValue.length > 50 ) {
		setErrorFor(firstname, 'Name character must not exceed 50 characters');
    isValid = false;
	}
	else {
		setValidFor(firstname);
	}
  
  //Lastname Validation
	
	if(lastnameValue === '') {
		setErrorFor(lastname, 'Name cannot be blank');
    isValid = false;
	}
  else if (!isName(lastnameValue)) {
		setErrorFor(lastname, 'Not a valid name');
    isValid = false;
	} 
	else if (lastnameValue.length > 50 ) {
		setErrorFor(laststname, 'Name character must not exceed 50 characters');
    isValid = false;
	}
	else {
		setValidFor(lastname);
	}
	
	//Email Validation
	if(emailValue === '') {
		setErrorFor(email, 'Email cannot be blank');
    isValid = false;
	} 
	else if (!isEmail(emailValue)) {
		setErrorFor(email, 'Not a valid email');
    isValid = false;
	} 
	else {
		setValidFor(email);
	}
	
	
	//Password Validation
	if(passwordValue === '') {
		setErrorFor(password, 'Password cannot be blank');
    isValid = false;
	} 
	else if (!isPassword(passwordValue)) {
		setErrorFor(password, 'Password length should be between 8 to 25 characters and must contain a lowercase letter, an uppercase letter, a number and a special character ');
    isValid = false;
  }
	else {
		setValidFor(password);
	}
	
	
	//Password Confirm Validation
	if(password2Value === '') {
		setErrorFor(password2, 'Password confirmation cannot be blank');
    isValid = false;
	} 
	else if(passwordValue !== password2Value) {
		setErrorFor(password2, 'Passwords do not match');
    isValid = false;
	} 
	else{
		setValidFor(password2);
	}
	
	//question Validation
	if(questionValue === '') {
		setErrorFor(question, 'Please select a question');
    isValid = false;
	} 
	else{
		setValidFor(question);
	}
	
	//Answer Validation
	if(answerValue === '') {
		setErrorFor(answer, 'Answer cannot be blank');
    isValid = false;
	}
	else if (answerValue.length < 5 || answerValue.length > 50 ) {
		setErrorFor(answer, 'Answer must be 5 to 50 characters');
    isValid = false;
	}
	else {
		setValidFor(answer);
	}
  return isValid;
}