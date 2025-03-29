#!/usr/bin/env perl

# lsftop_test_data.pl - Generate mock LSF job data for testing lsftop
# Usage: ./lsftop_test_data.pl > mock_bjobs_output.txt
#
# This script generates realistic-looking LSF job data that can be used
# to test the lsftop utility without an actual LSF cluster.

use strict;
use warnings;
use POSIX qw(strftime);
use List::Util qw(shuffle);

# Configuration for mock data generation
my $NUM_JOBS = 100;  # Total number of jobs to generate
my $NUM_USERS = 5;   # Number of different users
my $NUM_GROUPS = 8;  # Number of different job groups

# Generate random users
my @users = map { "user" . $_ } (1..$NUM_USERS);

# Generate random job groups
my @job_groups = (
    "/project1",
    "/project1/subgroup1",
    "/project1/subgroup2",
    "/project2",
    "/project2/analysis",
    "/project2/simulation",
    "/testing",
    "/production"
);

# Generate random queues
my @queues = qw(normal short long gpu interactive high_mem);

# Generate random hosts
my @hosts = map { "host" . $_ . ".example.com" } (1..10);
my @exec_hosts = (@hosts, "compute-0-1", "compute-0-2", "compute-1-1", "gpu-0-1");

# Generate random job statuses with weighted distribution
my @statuses = (
    ("RUN") x 50,     # 50% running
    ("PEND") x 30,    # 30% pending
    ("DONE") x 10,    # 10% done
    ("EXIT") x 5,     # 5% exit
    ("ZOMBI") x 3,    # 3% zombie
    ("UNKWN") x 2     # 2% unknown
);

# Generate random job names
my @job_prefixes = qw(analysis simulation backup test processing render compile optimize validate extract transform);
my @job_suffixes = qw(data model results batch job task process run iteration phase);

# Function to generate a random job name
sub random_job_name {
    my $prefix = $job_prefixes[int(rand(@job_prefixes))];
    my $suffix = $job_suffixes[int(rand(@job_suffixes))];
    return "$prefix\_$suffix";
}

# Function to generate a random timestamp within the last 7 days
sub random_timestamp {
    my $seconds_ago = int(rand(7 * 24 * 60 * 60));
    my $timestamp = time() - $seconds_ago;
    return strftime("%b %d %H:%M:%S", localtime($timestamp));
}

# Function to generate random CPU time
sub random_cpu_time {
    my $hours = int(rand(100));
    my $minutes = int(rand(60));
    my $seconds = int(rand(60));
    return sprintf("%d:%02d:%02d", $hours, $minutes, $seconds);
}

# Function to generate random memory usage
sub random_memory {
    my $mem = int(rand(32000));
    return "${mem}MB";
}

# Generate the mock jobs
my @jobs;
for my $i (1..$NUM_JOBS) {
    my $jobid = 10000 + $i;
    my $user = $users[int(rand(@users))];
    my $status = $statuses[int(rand(@statuses))];
    my $queue = $queues[int(rand(@queues))];
    my $from_host = $hosts[int(rand(@hosts))];
    
    # For pending jobs, exec_host should be empty
    my $exec_host = ($status eq "PEND") ? "-" : $exec_hosts[int(rand(@exec_hosts))];
    
    my $job_name = random_job_name();
    my $submit_time = random_timestamp();
    
    # CPU and memory usage should be higher for longer-running jobs
    my $cpu_used = ($status eq "RUN" || $status eq "DONE") ? random_cpu_time() : "0:00:00";
    my $mem = ($status eq "RUN" || $status eq "DONE") ? random_memory() : "0MB";
    
    my $job_group = $job_groups[int(rand(@job_groups))];
    
    # Format the job data as it would appear from bjobs command
    # Use tab as a delimiter to ensure proper column alignment
    my $job_data = join("\t", 
        $jobid, $user, $status, $queue, $from_host, $exec_host, 
        $job_name, $submit_time, $cpu_used, $mem, $job_group
    );
    
    push @jobs, $job_data;
}

# Print all jobs
foreach my $job (@jobs) {
    print "$job\n";
}
