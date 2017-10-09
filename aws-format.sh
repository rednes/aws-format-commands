#!/bin/bash

# EC2用Regionを取得してRegion毎に実行する
for region in $(aws ec2 describe-regions --query "Regions[].RegionName" --output text)
do
    echo "[$region]"

    # 全てのEC2インスタンスを取得して全部STOPする
    echo "  [EC2]"
    for instance in $(aws ec2 describe-instances --query "Reservations[].Instances[].InstanceId" --output text --region $region)
    do
        aws ec2 stop-instances --instance-ids $instance --output text --region $region
    done

    # 全てのELB LoadBalancerArnを取得して全部DELETEする
    echo "  [ELB]"
    for lba in $(aws elbv2 describe-load-balancers --query "LoadBalancers[].LoadBalancerArn" --output text --region $region)
    do
        echo "    Delete:$lba"
        aws elbv2 delete-load-balancer --load-balancer-arn $lba --region $region
    done

    # 全てのELB TargetGroupArnを取得して全部DELETEする
    for tga in $(aws elbv2 describe-target-groups --query "TargetGroups[].TargetGroupArn" --output text --region $region)
    do
        echo "    Delete:$tga"
        aws elbv2 delete-target-group --target-group-arn $tga --region $region
    done
done

# RDS用Regionを取得してRegion毎に実行する
for region in $(aws rds describe-source-regions --query "SourceRegions[].RegionName" --output text)
do
    echo "[$region]"

    # 全てのRDSインスタンスを取得して全部DELETEする
    echo "  [RDS]"
    for instance in $(aws rds describe-db-instances --query "DBInstances[].DBInstanceIdentifier" --output text --region $region)
    do
        echo "     Delete:$instance"
        aws rds delete-db-instance --db-instance-identifier $instance --skip-final-snapshot --output text --region $region
    done
done
