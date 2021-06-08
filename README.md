# ansible-yet-another-starter
Ansible, alas, is sometimes the right tool for the job. This is my old skeleton for organizing playbooks.

Bringing you yesterday's technology... today!

## What is this? 
This is the skeleton structure I used for my Ansible playbooks and administrivia in 2015. As of this writing, it's nearly 2021, but it doesn't look like the landscape has  changed all that much.

Ansible is unopinionated by design, so your ansible code base will be as neat or as gnarly as you allow it to be.

For a brief period in 2015, I loved Ansible. Then I got better. 

During that time, it looks like I developed some opinions on how playbooks should be organized. During the intervening time, I willfully forgot those opinions.

For a recent personal project, I had to image physical hardware. In retrospect, I should have set up [bare metal provisioning](https://rackn.com/rebar/), but the "toy scale" nature of the work was  necessarily high-touch enough that it didn't seem worth the effort at the time. 

And thus it came to pass that I needed ... Ansible. *So... we meet again.*

I remembered I *had* opinions, but not what they were. I also recalled how hard it was to go from a blank page to organized playbooks without creating a spectacular mess. Ansible's documentation has some best-practice notes, but Ansible itself won't provide the prescription you crave. 

After downloading a few promising entrants that matched my taste, I inadvertently `cd`'d into the wrong directory, and found my old scaffolding for plays. LOL. 

## How to use this
1. Wait for me to document it. `FIXME: update when documented`
2. Rifle through it and get ideas

## Bonus Opinions
### But...  What About Terraform? 
Terraform vs Ansible is almost as big a myth as Nomad vs. Kubernetes. Ansible and Terraform excel at different things. They are complementary tools built to work with distinct patterns. The best analogy I can think of right now is shell scripts vs purpose-built utilities. 

For rapid R&D-- the type you do on Day -120, prototyping, maybe rapid response on Day 0, or for *analysis* on Day 2+-- that's where Ansible shines. When you have to work outside infrastructure automation-- possibly because you're assembling it-- Ansible is your friend. 

While Terraform can be coaxed into performing so many tasks, doing things well starts with using the right tool for the job. You can throw some combination of Packer and Vagrant at *parts* of this development cycle, *sometimes*, but it is not always possible or practical to operate within that pattern. For some problems, it's also slow to the point of being impractical. 

In production, if you have to SSH into something, you've already lost. With the possible exception of bootstrapping systems that themselves run immutable infrastructure, and the more tenuous "I'm only using this as a temporary overlay/ crutch between new builds"-- *that's a familiar and slippery slope you're on there, my friend*-- Ansible is not the tool you want for your large-scale production IaaS environment. That's Terraform's job, and  one ridiculously long sentence. 

There is a delta between how things *should* be orchestrated, and how they often are. Ansible is great for the ad-hoc side of that delta. 

### Conclusion
Don't try to wield Terraform as a golden hammer, and don't mistake Ansible for infrastructure as code. 

Also, here's how I organized my plays in 2015. 
