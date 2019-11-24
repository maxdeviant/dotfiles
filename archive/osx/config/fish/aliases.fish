function ll
    ls -al
end

function gll
    git log --graph --date=short --pretty=format:'%Cgreen%h %Cblue%cd (%cr) %Cred%an%C(yellow)%d%Creset: %s'
end

function glll
    git log --graph --stat --date=short --pretty=format:'%Cgreen%h %Cblue%cd (%cr) %Cred%an%C(yellow)%d%Creset: %s'
end

function goops
    git add -A
    git reset --hard HEAD
end

# Converts ML code into Reason
alias mlre "pbpaste | refmt -use-stdin true -parse ml -print re -is-interface-pp false | pbcopy"

# Converts Reason code into ML
alias reml "pbpaste | refmt -use-stdin true -parse re -print ml -is-interface-pp false | pbcopy"
