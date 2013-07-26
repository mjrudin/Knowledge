# Code Reviews

* Your responsibility is to give feedback in how to improve the code. This includes not only errors, but style and anything else that improves code quality.
* Code for review **must be sent at class end (6PM)**. Don't send late code for review, because your review-pair needs to go to sleep.
* Don't worry about looking for subtle bugs; look mostly for major problems. A lot of your comments may be on general code style.
* In a way, the code review is more for the reviewer than the reviewed; we want you to see how other students crack the same problem.

## Github Instructions

### Programmers: add reviewers as collaborators

* Add both programming partners as collaborators to your github project.
    * Github names are listed [in Google Docs](https://docs.google.com/spreadsheet/ccc?key=0AkbhykGgDEyfdExiR2lHS1RrcTFnQlo0Y3FKd21DblE&usp=sharing).
* Add both reviewers as collaborators to your github project.
* Add your instructor as a collaborator.
    * [jonathanlemuel](https://github.com/jonathanlemuel)
* Adding someone as a collaborator will have github send them an email with the link to your repo.
    * You shouldn't have to email your reviewers your code directly.

### Reviewers: comment on the code

* Clone the programmer's repository.
    * You don't need to fork it; you have commit access to the repo.
* Create a branch called `review-#{last_name}`; for instance, `review-tamboer`.
    * `git checkout -b review-tamboer`
* Add comments in the format "# REV: [comment goes here]"
* Commit.
* Push your branch to the repo: `git push origin review-tamboer`
* Send **both members** of the programmer pair an email letting them know the review is complete. CC your instructor (jonathan@appacademy.io).
* **Email your review back by 10PM**; people don't want late code reviews.

### Programmers: read the reviews

* On the github repo page, click "Branches".
* You should see the pushed review branches (e.g., `review-tamboer`)
* To view the comments, click "Compare"
