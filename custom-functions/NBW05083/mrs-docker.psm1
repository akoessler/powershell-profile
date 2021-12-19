
function mrsdocker(
    [ValidateSet('login','build','push')]
    [String]
    $arg,
    [parameter(ValueFromRemainingArguments = $true)]
    [string[]]
    $Passthrough)
{
    $name=((Get-Location) | Get-Item).Name;
    Write-Host "Run docker command for: " . $name

    $tag = "gitlab-registry.eurofunk.com/mrs/app/" + $name + ":latest"

    switch($arg)
    {
        "login" {
            Write-Host "docker login gitlab-registry.eurofunk.com $Passthrough"
            docker login gitlab-registry.eurofunk.com $Passthrough
        }
        "build" {
            Write-Host "docker build -t $tag -f etc/config/docker/app/Dockerfile . $Passthrough"
            docker build -t $tag -f etc/config/docker/app/Dockerfile . $Passthrough
        }
        "push" {
            Write-Host "docker push $tag $Passthrough"
            docker push $tag $Passthrough
        }
        default {
            Write-Host "docker $arg $Passthrough"
            docker $arg $Passthrough
        }
    }
}
